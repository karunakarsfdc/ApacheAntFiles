public class AccountOpportunityController {
    
    public static Map<Integer, String> calendarMap = new Map<Integer, string>{
        1 => 'January',
        2 => 'February',
        3 => 'March',
        4 => 'April',
        5 => 'Map',
        6 => 'June',
        7 => 'July',
        8 => 'August',
        9 => 'September',
        10 => 'October',
        11 => 'November',
        12 => 'December'
    };
    
    public class AccountOpportunityWrapper{
        @AuraEnabled public String accountName;
        @AuraEnabled public String createdDate;
        @AuraEnabled public List<String> opportunityNames;
    }
    
    @AuraEnabled
    public static void fetchOpportunitiesbyDate(){
        List<Opportunity> opptyList = [SELECT Id, Name, CreatedDate, Account.Name FROM Opportunity WHERE AccountId != null];
        List<AccountOpportunityWrapper> accOppList = new List<AccountOpportunityWrapper>();
        Map<String, List<String>> accOppMap = new Map<String, List<String>>();
        for(Opportunity opp : opptyList){
            Date oppDate = Date.valueOf(opp.CreatedDate);
            String OppCreatedMonth = calendarMap.get(Integer.valueOf(oppDate.month()));
            String oppCreatedYear = String.valueOf(oppDate.year()); 
            String oppCreatedDate = OppCreatedMonth + ' - ' + oppCreatedYear;
            //System.debug(oppCreatedDate);
            
            if(String.isNotBlank(oppCreatedDate) && String.isNotBlank(opp.Account.Name)){
               String nameDateKey = oppCreatedDate + ':' +opp.Account.Name;
                if(!accOppMap.containsKey(nameDateKey)){
                    accOppMap.put(nameDateKey,new List<String>());
                }
                	accOppMap.get(nameDateKey).add(opp.Name);
            }
        }
        System.debug('##accOppMap##'+accOppMap);
        
        for(String key : accOppMap.keySet()){
            AccountOpportunityWrapper accOpp = new AccountOpportunityWrapper();
            accOpp.accountName = key.right(key.indexOf(':'));
            accOpp.createdDate = key.left(key.indexOf(':'));
            accOpp.opportunityNames = accOppMap.get(key);
            accOppList.add(accOpp);
        }
        System.debug('##accOppList##'+accOppList);
    }

}